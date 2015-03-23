require 'test_helper'
require 'minitest/autorun'

class DupTest < ActiveSupport::TestCase
  fixtures :all

  describe PolyBelongsTo::Dup do
    it "has method :pbt_dup_build" do
      User.instance_methods.must_include(:pbt_dup_build)
      User.methods.must_include(:pbt_dup_build)
    end

    it "has method :pbt_deep_dup_build" do
      User.instance_methods.must_include(:pbt_deep_dup_build)
      User.methods.must_include(:pbt_deep_dup_build)
    end

    it "#pbt_dup_build builds copy from dup'd attributes" do
      user = users(:bob)
      susan_prof = profiles(:susan_prof)
      contact = user.contacts.new
      contact.pbt_dup_build( susan_prof )
      CleanAttrs[contact.profile].must_equal CleanAttrs[susan_prof]
    end
    
    it "#pbt_deep_dup_build builds deep copy of dup'd attributes" do
      user1 = users(:steve)
      bob_prof = profiles(:bob_prof)
      contact = user1.contacts.new
      contact.pbt_deep_dup_build(bob_prof)
      CleanAttrs[contact.profile                                                        ].
        must_equal CleanAttrs[bob_prof]
      CleanAttrs[contact.profile.addresses.first                                        ].
        must_equal CleanAttrs[bob_prof.addresses.first]
      CleanAttrs[contact.profile.addresses.first.squishies.first                        ].
        must_equal CleanAttrs[bob_prof.addresses.first.squishies.first]
      CleanAttrs[contact.profile.addresses.first.geo_location                           ].
        must_equal CleanAttrs[bob_prof.addresses.first.geo_location]
      CleanAttrs[contact.profile.addresses.first.geo_location.squishies.first           ].
        must_equal CleanAttrs[bob_prof.addresses.first.geo_location.squishies.first]
      CleanAttrs[contact.profile.addresses.last                                         ].
        must_equal CleanAttrs[bob_prof.addresses.last]
      CleanAttrs[contact.profile.phones.first                                           ].
        must_equal CleanAttrs[bob_prof.phones.first]
      CleanAttrs[contact.profile.phones.first.squishy                                   ].
        must_equal CleanAttrs[bob_prof.phones.first.squishy]
      CleanAttrs[contact.profile.phones.last                                            ].
        must_equal CleanAttrs[bob_prof.phones.last]
      CleanAttrs[contact.profile.photo                                                  ].
        must_equal CleanAttrs[bob_prof.photo]
    end
  end

  describe "handles circular references like a champ!" do
    alpha = Alpha.new; alpha.save
    beta = alpha.betas.build; beta.save
    capa = beta.capas.build; capa.save
    delta = capa.deltas.build; delta.save
    alpha.update(delta_id: delta.id)
    it "is a circle" do
      alpha.pbt_parent.must_equal delta
      beta.pbt_parent.must_equal alpha
      capa.pbt_parent.must_equal beta
      delta.pbt_parent.must_equal capa
    end
    it "clones without duplicating cirular reference" do
      alpha2 = Alpha.new( CleanAttrs[alpha] )
      CleanAttrs[alpha2].must_equal CleanAttrs[alpha]
      alpha2.pbt_deep_dup_build(beta)
      #alpha2.save
      CleanAttrs[alpha2.betas.first].must_equal CleanAttrs[beta]
      CleanAttrs[alpha2.betas.first.capas.first].must_equal CleanAttrs[capa]
      CleanAttrs[alpha2.betas.first.capas.first.deltas.first].must_equal CleanAttrs[delta]
      CleanAttrs[alpha2.betas.first.capas.first.deltas.firsti.alphas.first].must_be_nil
    end
  end
end

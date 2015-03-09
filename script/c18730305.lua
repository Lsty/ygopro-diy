--美少女3
function c18730305.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18730305)
	e1:SetTarget(c18730305.target)
	e1:SetOperation(c18730305.activate)
	c:RegisterEffect(e1)
end
function c18730305.filter(c,e,tp,m)
	if not c:IsSetCard(0xabb) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	local mg=nil
	if c.mat_filter then
		mg=m:Filter(c.mat_filter,c)
	else
		mg=m:Clone()
		mg:RemoveCard(c)
	end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c18730305.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c18730305.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c18730305.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c18730305.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if tc.mat_filter then
			mg1=mg1:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg1:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)>0 then
		local ct=mat:GetCount()
		local e1=Effect.CreateEffect(e:GetHandler())
    	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      	e1:SetCode(EVENT_PHASE+PHASE_END)
	    e1:SetReset(RESET_PHASE+PHASE_END)
    	e1:SetCountLimit(1)
		e1:SetLabel(ct)
    	e1:SetOperation(c18730305.droperation)
    	Duel.RegisterEffect(e1,tp)
	    end
	end
end
function c18730305.droperation(e,tp,eg,ep,ev,re,r,rp)
		local at=e:GetLabel()
	    Duel.Hint(HINT_CARD,0,18730305)
	    Duel.Draw(tp,at,REASON_EFFECT)
end
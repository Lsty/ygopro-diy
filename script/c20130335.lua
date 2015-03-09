--京子
function c20130335.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c20130335.thcon)
	e1:SetTarget(c20130335.sptg)
	e1:SetOperation(c20130335.spop)
	c:RegisterEffect(e1)
end
function c20130335.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c20130335.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c20130335.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,20130324,0,0x4011,0,0,2,RACE_FIEND,ATTRIBUTE_LIGHT) then
		local token1=Duel.CreateToken(tp,20130324)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c20130335.sumlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token1:RegisterEffect(e1,true)
		local token2=Duel.CreateToken(tp,20130324)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UNRELEASABLE_SUM)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(c20130335.sumlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		token2:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c20130335.sumlimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
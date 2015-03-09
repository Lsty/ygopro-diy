--平松妙子
function c20130330.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c20130330.spcon)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c20130330.cost)
	e2:SetTarget(c20130330.sptg)
	e2:SetOperation(c20130330.spop)
	c:RegisterEffect(e2)
end
function c20130330.spcon(e,c,tp)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function c20130330.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckReleaseGroup(tp,c20130330.sumlimit1,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c20130330.sumlimit1,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c20130330.sumlimit1(c)
	return (c:IsRace(RACE_FIEND) or c:IsRace(RACE_SPELLCASTER)) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c20130330.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c20130330.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,20130324,0,0x4011,0,0,2,RACE_FIEND,ATTRIBUTE_LIGHT) then
		local token1=Duel.CreateToken(tp,20130324)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c20130330.sumlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token1:RegisterEffect(e1,true)
		local token2=Duel.CreateToken(tp,20130324)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UNRELEASABLE_SUM)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(c20130330.sumlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		token2:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c20130330.sumlimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
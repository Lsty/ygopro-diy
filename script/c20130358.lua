--死灵师 优克莉伍德·海尔赛兹
function c20130358.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c20130358.spcon)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c20130358.sptg)
	e2:SetOperation(c20130358.spop)
	c:RegisterEffect(e2)
end
function c20130358.spcon(e,c,tp)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20130358.sumlimit1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c20130358.sumlimit1(c)
	return (c:IsRace(RACE_FIEND) or c:IsRace(RACE_SPELLCASTER)) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsType(TYPE_TOKEN)
end
function c20130358.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c20130358.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,20130324,0,0x4011,0,0,2,RACE_FIEND,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,20130324)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c20130358.sumlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function c20130358.sumlimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
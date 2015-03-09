--传说治暗杀者 赛米拉米斯
function c999999.initial_effect(c)
    --token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c999999.sptg)
	e1:SetOperation(c999999.spop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c999999.tgcon)
	e2:SetValue(c999999.tgvalue)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75878039,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c999999.tg)
	e3:SetOperation(c999999.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c999999.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,999997,0x4011,0x4011,0,0,1,RACE_WINDBEAST,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c999999.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,999997,0x4011,0x4011,0,0,1,RACE_WINDBEAST,ATTRIBUTE_WIND) then
		local token=Duel.CreateToken(tp,999997)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetTargetRange(LOCATION_MZONE,0)
	    e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	    e1:SetTarget(c999999.target)
	    e1:SetValue(1)
	    token:RegisterEffect(e1,true)
	    local e2=e1:Clone()
	    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	    e2:SetValue(c999999.tglimit)
	    token:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c999999.target(e,c)
	return not c:IsType(TYPE_TOKEN)
end
function c999999.tglimit(e,re,rp)
	return rp~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function c999999.tgcon(e)
	return  Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c999999.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer() and  re:IsActiveType(TYPE_MONSTER)
end
function c999999.filter(c)
	local code=c:GetCode()
	return (code==999998) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c999999.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

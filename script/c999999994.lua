--´«ËµÖ®°µÉ±Õß ¹þÉ£¡¤Èø°ÍºÕ
function c999999994.initial_effect(c)
    --token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c999999994.spcost)
	e1:SetTarget(c999999994.sptg)
	e1:SetOperation(c999999994.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c999999994.descost)
	e2:SetTarget(c999999994.destg)
	e2:SetOperation(c999999994.desop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75878039,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,999999994+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c999999994.tg)
	e3:SetOperation(c999999994.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
    --immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetCondition(c999999994.tgcon)
	e5:SetValue(c999999994.tgvalue)
	c:RegisterEffect(e5)
end
function c999999994.ccfilter(c)
	return c:IsCode(999989938) and not c:IsDisabled()
end
function c999999994.costfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsDiscardable()
end
function c999999994.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	--[[if  Duel.IsExistingMatchingCard(c999999994.ccfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.GetFlagEffect(tp,999989938)==0 then
    if chk==0 then return Duel.GetFlagEffect(tp,999989938)==0  end
	Duel.RegisterFlagEffect(tp,999989938,RESET_PHASE+PHASE_END,0,1)
	 else--]]
	if chk==0 then return Duel.IsExistingMatchingCard(c999999994.costfilter,tp,LOCATION_HAND,0,1,nil)  end
	Duel.DiscardHand(tp,c999999994.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c999999994.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,999989942,0x4011,0x4011,100,100,1,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c999999994.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,999989942,0x4011,0x4011,100,100,1,RACE_WARRIOR,ATTRIBUTE_DARK) then
		local token1=Duel.CreateToken(tp,999989942)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		local token2=Duel.CreateToken(tp,999989942)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
function c999999994.refilter(c,tp)
	return c:IsCode(999989942) or c:IsCode(999999965) and c:IsControler(tp)
end
function c999999994.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if  Duel.IsExistingMatchingCard(c999999994.ccfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.GetFlagEffect(tp,999989938)==0 then
    if chk==0 then return Duel.GetFlagEffect(tp,999989938)==0  end
	Duel.RegisterFlagEffect(tp,999989938,RESET_PHASE+PHASE_END,0,1)
	 else
	if chk==0 then return e:GetHandler()
		and Duel.CheckReleaseGroup(tp,c999999994.refilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c999999994.refilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
end
function c999999994.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_MONSTER)
end
function c999999994.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c999999994.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999994.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c999999994.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c999999994.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c999999994.filter(c)
	local code=c:GetCode()
	return (code==999989943) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c999999994.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999994.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999994.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999994.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c999999994.tgcon(e)
	return  Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c999999994.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer() and  re:IsActiveType(TYPE_MONSTER)
end


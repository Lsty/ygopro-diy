--狂化召唤术
function c999999972.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,999999972+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c999999972.cost)
	e1:SetTarget(c999999972.target)
	e1:SetOperation(c999999972.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c999999972.descon)
	e2:SetOperation(c999999972.desop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c999999972.rmop)
	c:RegisterEffect(e3)
    --cannot ep
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_EP)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c999999972.becon)
	c:RegisterEffect(e4)
end
function c999999972.filter(c,e,tp)
     return Card.IsDiscardable and c:IsType(TYPE_EQUIP)
end
function c999999972.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999972.filter,tp,LOCATION_HAND,0,1,nil) and Duel.CheckLPCost(tp,1000) end
	Duel.DiscardHand(tp,c999999972.filter,1,1,REASON_COST+REASON_DISCARD)
    Duel.PayLPCost(tp,1000)
end
function c999999972.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and  (c:IsSetCard(0x984) or c:IsSetCard(0x985))
end
function c999999972.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c999999972.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c999999972.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c999999972.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
			if  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(800)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_DEFENCE_FINAL)
		e4:SetValue(0)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e5:SetCountLimit(1)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e5,true)
	    local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_MUST_ATTACK)
		e6:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
		c:SetCardTarget(tc)
	end
end
end
 function c999999972.becon(e)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and tc:IsAttackable()
end
function c999999972.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c999999972.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function c999999972.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
if tc then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
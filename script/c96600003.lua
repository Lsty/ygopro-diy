--孤高的保镖✟真田卿介
function c96600003.initial_effect(c)
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c96600003.valcon)
	c:RegisterEffect(e1)
	--lvdown
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_BATTLE_PHASE,TIMING_BATTLE_PHASE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c96600003.lvcon)
	e2:SetCost(c96600003.lvcost)
	e2:SetTarget(c96600003.lvtg)
	e2:SetOperation(c96600003.lvop)
	c:RegisterEffect(e2)
end
function c96600003.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c96600003.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x966)
end
function c96600003.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c96600003.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c96600003.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c96600003.filter1(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c96600003.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c96600003.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c96600003.filter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c96600003.filter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c96600003.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE)
	end
end
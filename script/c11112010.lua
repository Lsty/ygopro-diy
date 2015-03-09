--怪物猎人 大野猪王
function c11112010.initial_effect(c)
	c:SetStatus(STATUS_UNSUMMONABLE_CARD,true)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c11112010.condtion)
	e1:SetTarget(c11112010.target)
	e1:SetOperation(c11112010.operation)
	c:RegisterEffect(e1)
	--pierce & atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112010,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c11112010.atkcon)
	e2:SetCost(c11112010.atkcost)
	e2:SetTarget(c11112010.atktg)
	e2:SetOperation(c11112010.atkop)
	c:RegisterEffect(e2)
end
function c11112010.condtion(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:IsActiveType(TYPE_MONSTER)
		and e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c11112010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11112010.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11112010.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=1 and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c11112010.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c11112010.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15b) and c:IsAttackBelow(2000) and not c:IsHasEffect(EFFECT_PIERCE)
end
function c11112010.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11112010.atkfilter(chkc) end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 
	    and Duel.IsExistingTarget(c11112010.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c11112010.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11112010.atkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e2)
	end
end
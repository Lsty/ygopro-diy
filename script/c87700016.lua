--禁弹·星弧破碎
function c87700016.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c87700016.target)
	e1:SetOperation(c87700016.operation)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c87700016.thcon1)
	e2:SetTarget(c87700016.target1)
	e2:SetOperation(c87700016.thop1)
	c:RegisterEffect(e2)
	--instant
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c87700016.condition2)
	e3:SetTarget(c87700016.target2)
	e3:SetOperation(c87700016.operation)
	c:RegisterEffect(e3)
end
function c87700016.filter(c)
	return c:IsAbleToHand()
end
function c87700016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c87700016.filter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c87700016.filter,tp,LOCATION_MZONE,0,1,nil) and tn==tp
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.SelectYesNo(tp,aux.Stringid(87700016,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,c87700016.filter,tp,LOCATION_MZONE,0,1,1,nil)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		e:GetHandler():RegisterFlagEffect(87700016,RESET_PHASE+PHASE_END,0,1)
	else
		e:SetProperty(0)
		e:SetCategory(0)
	end
end
function c87700016.sumfilter(c)
	return c:IsSetCard(0x877) and c:IsSummonable(true,nil)
end
function c87700016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) then
		if Duel.IsExistingMatchingCard(c87700016.sumfilter,tp,LOCATION_HAND,0,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local g=Duel.SelectMatchingCard(tp,c87700016.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
			Duel.Summon(tp,g:GetFirst(),true,nil)
		end
	end
end
function c87700016.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEUP)~=0
		and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0 and rp==tp
end
function c87700016.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c87700016.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c87700016.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return (tn==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2))
end
function c87700016.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c87700016.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(87700016)==0
		and Duel.IsExistingTarget(c87700016.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c87700016.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(87700016,RESET_PHASE+PHASE_END,0,1)
end
--宇宙联合行星保护机构
function c32100016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetCondition(c32100016.coincon)
	e2:SetOperation(c32100016.coinop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c32100016.target)
	e3:SetOperation(c32100016.activate)
	c:RegisterEffect(e3)
end
function c32100016.coincon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetFlagEffect(tp,32100016)==0 and re:IsActiveType(TYPE_MONSTER)
end
function c32100016.coinop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,32100016)~=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(32100016,0)) then
		Duel.Hint(HINT_CARD,0,32100016)
		Duel.RegisterFlagEffect(tp,32100016,RESET_PHASE+PHASE_END,0,1)
		Duel.TossDice(ep,ev)
	end
end
function c32100016.filter(c)
	return c:IsFaceup() and c:GetAttack()==-2 and c:GetDefence()==-2 and c:IsAbleToHand()
end
function c32100016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c32100016.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c32100016.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c32100016.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c32100016.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
	end
end
--元素 木符·绿色风暴
function c82200011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c82200011.target)
	e2:SetValue(-100)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c82200011.condition)
	e3:SetTarget(c82200011.target1)
	e3:SetOperation(c82200011.operation)
	c:RegisterEffect(e3)
	--salvage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c82200011.condition1)
	e4:SetCost(c82200011.thcost)
	e4:SetTarget(c82200011.thtg)
	e4:SetOperation(c82200011.thop)
	c:RegisterEffect(e4)
end
function c82200011.target(e,c)
	return c:IsFaceup() and not c:IsSetCard(0x811)
end
function c82200011.cfilter(c,tp)
	return bit.band(c:GetReason(),0x41)==0x41 and c:IsControler(tp) and c:IsSetCard(0x811)
end
function c82200011.cfilter1(c)
	return c:IsFaceup() and c:IsCode(82200009)
end
function c82200011.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c82200011.cfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c82200011.cfilter1,tp,LOCATION_SZONE,0,1,nil)
end
function c82200011.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c82200011.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c82200011.cfilter2(c)
	return c:IsFaceup() and c:IsCode(82200010)
end
function c82200011.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82200011.cfilter2,tp,LOCATION_SZONE,0,1,nil)
end
function c82200011.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c82200011.filter(c)
	return c:IsSetCard(0x822) and c:GetCode()~=82200011 and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToHand()
end
function c82200011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c82200011.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82200011.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c82200011.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c82200011.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
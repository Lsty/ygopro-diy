--笨蛋 米斯蒂娅
function c31141530.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31141530,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,31141530)
	e1:SetCondition(c31141530.con)
	e1:SetCost(c31141530.cost1)
	e1:SetTarget(c31141530.target1)
	e1:SetOperation(c31141530.operation1)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31141530,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,31141530)
	e3:SetCost(c31141530.cost)
	e3:SetTarget(c31141530.target)
	e3:SetOperation(c31141530.operation)
	c:RegisterEffect(e3)
	--splimit
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ea:SetRange(LOCATION_GRAVE)
	ea:SetTargetRange(1,0)
	ea:SetTarget(c31141530.splimit)
	c:RegisterEffect(ea)
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetCode(EFFECT_CANNOT_SUMMON)
	eb:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	eb:SetRange(LOCATION_GRAVE)
	eb:SetTargetRange(1,0)
	eb:SetTarget(c31141530.splimit)
	c:RegisterEffect(eb)
end
function c31141530.con(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
	return e:GetHandler()==tc
end
function c31141530.splimit(e,c)
	return not c:IsRace(RACE_WINDBEAST)
end
function c31141530.costfilter(c)
	return c:IsSetCard(0x3d3) and c:IsAbleToGraveAsCost()
end
function c31141530.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31141530.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c31141530.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c31141530.filter(c)
	return c:IsSetCard(0x3d3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c31141530.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c31141530.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c31141530.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c31141530.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c31141530.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c31141530.cfilter(c)
	return c:IsSetCard(0x3d3) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c31141530.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31141530.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c31141530.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c31141530.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c31141530.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
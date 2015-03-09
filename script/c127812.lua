--「刻刻帝」 七之弹（Zayin）
function c127812.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c127812.cost)
	e1:SetTarget(c127812.target)
	e1:SetOperation(c127812.activate)
	c:RegisterEffect(e1)
end
function c127812.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fd=Duel.GetFieldCard(c:GetControler(),LOCATION_SZONE,5)
	if chk==0 then return fd and fd:IsCode(127808) and fd:IsCanRemoveCounter(c:GetControler(),0x16,4,REASON_COST) end
	local fd=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	fd:RemoveCounter(tp,0x16,4,REASON_RULE)
end
function c127812.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c127812.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

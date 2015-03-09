--「刻刻帝」 一之弹（Aleph）
function c127809.initial_effect(c)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)              
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c127809.cost)
	e1:SetTarget(c127809.target)
	e1:SetOperation(c127809.activate)
	c:RegisterEffect(e1)
end
function c127809.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fd=Duel.GetFieldCard(c:GetControler(),LOCATION_SZONE,5)
	if chk==0 then return fd and fd:IsCode(127808) and fd:IsCanRemoveCounter(c:GetControler(),0x16,1,REASON_COST) end
	local fd=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	fd:RemoveCounter(tp,0x16,1,REASON_RULE)
end
function c127809.filter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_SPELL+TYPE_TRAP) 
end
function c127809.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c127809.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c127809.filter2,tp,0,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c127809.filter2,tp,0,LOCATION_SZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c127809.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end


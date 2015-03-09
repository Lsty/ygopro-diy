--MARI的架空世界
function c19900040.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c19900040.cost)
	e1:SetTarget(c19900040.target)
	e1:SetOperation(c19900040.activate)
	c:RegisterEffect(e1)
end

function c19900040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,19900040)==0 end
	Duel.RegisterFlagEffect(tp,19900040,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c19900040.filter(c)
	return c:IsSetCard(0x199) and c:IsAbleToDeck()
end
function c19900040.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c19900040.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c19900040.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c19900040.filter,tp,LOCATION_GRAVE,0,3,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c19900040.tgfilter(c,e)
	return not c:IsRelateToEffect(e)
end
function c19900040.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:IsExists(c19900040.tgfilter,1,nil,e) then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.Draw(tp,1,REASON_EFFECT)
end

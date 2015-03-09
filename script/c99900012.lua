--自伤者之刑
function c99900012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c99900012.drtg)
	e2:SetOperation(c99900012.drop)
	c:RegisterEffect(e2)
end
function c99900012.filter(c)
	return c:IsSetCard(0x999) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c99900012.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetLocation()==LOCATION_REMOVED and chkc:GetControler()==tp and c99900012.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99900012.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,c99900012.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c99900012.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.BreakEffect()
		op=Duel.SelectOption(tp,aux.Stringid(99900012,0),aux.Stringid(99900012,1))
		if op==0 then
			Duel.Damage(tp,100,REASON_EFFECT)
		else
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
end
--镜现诗·不动的大图书馆
function c19300007.initial_effect(c)
	c:SetUniqueOnField(1,0,19300007)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c19300007.sptg)
	e2:SetOperation(c19300007.spop)
	c:RegisterEffect(e2)
end
function c19300007.cffilter(c)
	return c:IsSetCard(0x193) and not c:IsPublic()
end
function c19300007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19300007.cffilter,tp,LOCATION_HAND,0,1,nil) end
end
function c19300007.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if not Duel.IsExistingMatchingCard(c19300007.cffilter,tp,LOCATION_HAND,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c19300007.cffilter,tp,LOCATION_HAND,0,1,99,nil)
	Duel.ConfirmCards(1-tp,g)
	local ct=g:GetClassCount(Card.GetCode)
	if ct==2 and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) then
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
		Duel.ConfirmCards(tp,g)
	elseif ct==3 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif ct==4 then
		local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if dg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local rg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(rg)
			Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
		end
	elseif ct==5 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
	Duel.ShuffleHand(tp)
end
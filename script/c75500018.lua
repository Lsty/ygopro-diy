--梦日记-彩
function c75500018.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x755),4,2)
	c:EnableReviveLimit()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c75500018.cost)
	e1:SetTarget(c75500018.target)
	e1:SetOperation(c75500018.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c75500018.setcon)
	e2:SetTarget(c75500018.settg)
	e2:SetOperation(c75500018.setop)
	c:RegisterEffect(e2)
end
function c75500018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c75500018.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function c75500018.cfilter1(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_SPELL)
end
function c75500018.cfilter2(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_TRAP)
end
function c75500018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,4) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	e:SetLabel(res)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,4)
end
function c75500018.operation(e,tp,eg,ep,ev,re,r,rp)
	local res=e:GetLabel()
	Duel.DiscardDeck(1-tp,4,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if res==0 then
		local ct=g:FilterCount(c75500018.cfilter,nil)
		if ct==0 then return end
		if ct==1 and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 then
			local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			Duel.ConfirmCards(tp,hg)
			Duel.ShuffleHand(1-tp)
		elseif ct==2 and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 then
			local g1=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
			Duel.ConfirmCards(tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g1:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		elseif ct>=3 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>1 then
			local tg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
			Duel.ConfirmCards(tp,tg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local cg=tg:Select(tp,2,2,nil)
			Duel.SendtoGrave(cg,REASON_EFFECT)
		end
	elseif res==1 then
		local ct=g:FilterCount(c75500018.cfilter1,nil)
		if ct==0 then return end
		if ct==1 and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 then
			local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			Duel.ConfirmCards(tp,hg)
			Duel.ShuffleHand(1-tp)
		elseif ct==2 and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 then
			local g1=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
			Duel.ConfirmCards(tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g1:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		elseif ct>=3 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>1 then
			local tg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
			Duel.ConfirmCards(tp,tg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local cg=tg:Select(tp,2,2,nil)
			Duel.SendtoGrave(cg,REASON_EFFECT)
		end
	elseif res==2 then
		local ct=g:FilterCount(c75500018.cfilter2,nil)
		if ct==0 then return end
		if ct==1 and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 then
			local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			Duel.ConfirmCards(tp,hg)
			Duel.ShuffleHand(1-tp)
		elseif ct==2 and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 then
			local g1=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
			Duel.ConfirmCards(tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g1:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		elseif ct>=3 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>1 then
			local tg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
			Duel.ConfirmCards(tp,tg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local cg=tg:Select(tp,2,2,nil)
			Duel.SendtoGrave(cg,REASON_EFFECT)
		end
	end
end
function c75500018.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c75500018.filter(c)
	return c:IsSetCard(0x755) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c75500018.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75500018.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c75500018.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75500018.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
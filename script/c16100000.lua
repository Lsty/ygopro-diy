--超电磁炮 御坂美琴
function c16100000.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),5,3,nil,nil,5)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16100000,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c16100000.cost)
	e1:SetTarget(c16100000.destg)
	e1:SetOperation(c16100000.desop)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16100000,1))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c16100000.cost)
	e2:SetTarget(c16100000.hdtg)
	e2:SetOperation(c16100000.hdop)
	c:RegisterEffect(e2)
	--deckes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16100000,2))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c16100000.cost)
	e3:SetTarget(c16100000.ddtg)
	e3:SetOperation(c16100000.ddop)
	c:RegisterEffect(e3)
end
function c16100000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,3,REASON_COST) end
	c:RemoveOverlayCard(tp,3,3,REASON_COST)
end
function c16100000.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c16100000.desop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
function c16100000.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0	end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,1-tp,1)
end
function c16100000.hdop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local h=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	local tg=Duel.GetMatchingGroup(nil,p,LOCATION_GRAVE,0,nil)
	local ct=tg:GetCount()
	if ct<h then h=ct end
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sel=tg:Select(1-p,h,h,nil)
		Duel.SendtoHand(sel,nil,REASON_EFFECT)
	end
end
function c16100000.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local gc=Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)
		local dc=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		return gc>0 and dc>=gc end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,gc)
end
function c16100000.ddop(e,tp,eg,ep,ev,re,r,rp)
	local gc=Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)
	Duel.DiscardDeck(1-tp,gc,REASON_EFFECT)
end
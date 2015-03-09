--时符·夜雾的幻影杀人鬼
function c98700022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c98700022.condition)
	e1:SetCost(c98700022.cost)
	e1:SetTarget(c98700022.target)
	e1:SetOperation(c98700022.activate)
	c:RegisterEffect(e1)
	if not c98700022.global_check then
		c98700022.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c98700022.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c98700022.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsSetCard(0x986) and not re:GetHandler():IsSetCard(0x987) then
		Duel.RegisterFlagEffect(rp,98700022,RESET_PHASE+PHASE_END,0,1)
	end
end
function c98700022.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function c98700022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98700022)==0 end
	Duel.RegisterFlagEffect(tp,98700022,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c98700022.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98700022.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x986) and not re:GetHandler():IsSetCard(0x987)
end
function c98700022.filter(c)
	return c:IsSetCard(0x986) and c:IsAbleToHand()
end
function c98700022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local ct=Duel.GetCurrentChain()
	for i=1,ct do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		ng:AddCard(tc)
	end
	if ng:FilterCount(Card.IsSetCard,nil,0x986)>1 then
		Duel.SetTargetPlayer(1-tp)
		local dam=ct*200
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	end
	if ng:FilterCount(Card.IsSetCard,nil,0x986)>2 and Duel.IsExistingMatchingCard(c98700022.filter,tp,LOCATION_DECK,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetTargetParam(2)
	end
	if ng:FilterCount(Card.IsSetCard,nil,0x986)>3 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_HAND)
		Duel.SetTargetParam(3)
	end
	if ng:FilterCount(Card.IsSetCard,nil,0x986)>4 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
		Duel.SetTargetParam(4)
	end
end
function c98700022.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ct=Duel.GetCurrentChain()
	if d>=1 then
		Duel.Damage(p,ct*200,REASON_EFFECT)
	end
	if d>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c98700022.filter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if d>=3 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
	if d>=4 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
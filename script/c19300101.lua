--镜现诗·被遗弃的人偶
function c19300101.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x193),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c19300101.con)
	e1:SetTarget(c19300101.tg)
	e1:SetOperation(c19300101.op)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c19300101.condition)
	e2:SetTarget(c19300101.target)
	e2:SetOperation(c19300101.operation)
	c:RegisterEffect(e2)
end
function c19300101.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c19300101.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c19300101.filter(c)
	return (c:IsLocation(LOCATION_HAND) and not c:IsPublic()) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFacedown() and not c:IsPublic())
end
function c19300101.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
	local g1=Duel.GetOperatedGroup()
	local sg1=g1:GetFirst()
	if sg1:IsType(TYPE_MONSTER) then
		local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,TYPE_MONSTER)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		else
			local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			if hg:GetCount()~=0 then
				Duel.ConfirmCards(tp,hg)
				Duel.ShuffleHand(1-tp)
			end
		end
	elseif sg1:IsType(TYPE_SPELL) then
		local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,TYPE_SPELL)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		else
			local hg=Duel.GetMatchingGroup(c19300101.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
			if hg:GetCount()~=0 then
				Duel.ConfirmCards(tp,hg)
				Duel.ShuffleHand(1-tp)
			end
		end
	else
		local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,TYPE_TRAP)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		else
			local hg=Duel.GetMatchingGroup(c19300101.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
			if hg:GetCount()~=0 then
				Duel.ConfirmCards(tp,hg)
				Duel.ShuffleHand(1-tp)
			end
		end
	end
end
function c19300101.filter1(c)
	return c:IsSetCard(0x193) and c:IsLevelBelow(3)
end
function c19300101.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19300101.filter1,1,nil)
end
function c19300101.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c19300101.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--时符·咲夜的世界
function c98700023.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c98700023.regop)
	c:RegisterEffect(e2)
	--cannot disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0)
	e3:SetTarget(c98700023.target1)
	c:RegisterEffect(e3)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c98700023.target1)
	e4:SetValue(c98700023.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c98700023.target1)
	e5:SetValue(c98700023.effectfilter)
	c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetCountLimit(1)
	e6:SetCondition(c98700023.drcon)
	e6:SetTarget(c98700023.drtg)
	e6:SetOperation(c98700023.drop)
	c:RegisterEffect(e6)
end
function c98700023.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp~=tp and c:IsReason(REASON_DESTROY) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
			and Duel.GetCurrentPhase()~=PHASE_STANDBY and Duel.GetCurrentPhase()~=PHASE_MAIN1 then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c98700023.bpcon)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c98700023.bpcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c98700023.etarget(e,c)
	return c:IsFaceup() and c:IsSetCard(0x987)
end
function c98700023.target1(e,c)
	return c:IsSetCard(0x987) or c:IsSetCard(0x986)
end
function c98700023.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and (tc:IsSetCard(0x987) or tc:IsSetCard(0x986))
end
function c98700023.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c98700023.filter(c)
	return c:IsSetCard(0x986) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c98700023.filter1(c)
	return c:IsSetCard(0x987) and c:IsAbleToHand()
end
function c98700023.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98700023.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c98700023.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98700023.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c98700023.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,1,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(c98700023.filter1,tp,LOCATION_DECK,0,nil)
		local cg=sg:RandomSelect(tp,1)
		Duel.SendtoHand(cg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,cg)
	end
end
--创符「流放人偶」
function c13130180.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13130180+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c13130180.activate)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c13130180.aclimit)
	c:RegisterEffect(e2)
	--effect damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,13130181)
	e3:SetCost(c13130180.cost)
	e3:SetCondition(c13130180.discon)
	e3:SetOperation(c13130180.disop)
	c:RegisterEffect(e3)
end
function c13130180.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c13130180.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c13130180.damfilter(c,sp)
	return c:GetSummonPlayer()==sp
end
function c13130180.drop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c13130180.damfilter,1,nil,1-tp) then
		Duel.Hint(HINT_CARD,0,13130180)
		Duel.Damage(1-tp,400,REASON_EFFECT)
	end
end
function c13130180.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c13130180.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c13130180.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xddd)
end
function c13130180.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c13130180.filter,tp,LOCATION_MZONE,0,1,nil) and (Duel.IsPlayerCanDiscardDeck(tp,2) or Duel.IsPlayerCanDiscardDeck(1-tp,2))
end
function c13130180.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,2) then
		if Duel.IsPlayerCanDiscardDeck(1-tp,2) and not Duel.SelectYesNo(tp,aux.Stringid(13130180,0)) then
			Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
		else
			Duel.DiscardDeck(tp,2,REASON_EFFECT)
		end
	elseif Duel.IsPlayerCanDiscardDeck(1-tp,2) then
		Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
	end
end
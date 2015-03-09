--荆棘蔷薇园
function c93300012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c93300012.damcon2)
	e2:SetOperation(c93300012.damop2)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c93300012.cost)
	e3:SetTarget(c93300012.target)
	e3:SetOperation(c93300012.operation)
	c:RegisterEffect(e3)
	if not c93300012.global_check then
		c93300012.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c93300012.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c93300012.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c93300012.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsRace(RACE_PSYCHO) then
			c93300012[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c93300012.clear(e,tp,eg,ep,ev,re,r,rp)
	c93300012[0]=true
	c93300012[1]=true
end
function c93300012.cfilter(c)
	return c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack()
end
function c93300012.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c93300012.cfilter,Duel.GetTurnPlayer(),LOCATION_MZONE,0,1,nil)
end
function c93300012.damop2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	Duel.Hint(HINT_CARD,0,93300012)
	Duel.Damage(p,500,REASON_EFFECT)
end
function c93300012.filter1(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToDeckAsCost()
end
function c93300012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c93300012[tp] and Duel.IsExistingMatchingCard(c93300012.filter1,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c93300012.filter1,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c93300012.splimit)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function c93300012.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_PSYCHO)
end
function c93300012.filter(c)
	return c:IsRace(RACE_PSYCHO) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c93300012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c93300012.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c93300012.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c93300012.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(93300012,0))) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
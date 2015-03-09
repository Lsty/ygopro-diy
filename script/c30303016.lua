--奴隶市场
function c30303016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2222282,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,30303016)
	e2:SetCost(c30303016.cost)
	e2:SetTarget(c30303016.thtg)
	e2:SetOperation(c30303016.thop)
	c:RegisterEffect(e2)
	if not c30303016.global_check then
		c30303016.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c30303016.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c30303016.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
--sp limit
function c30303016.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsSetCard(0xabb) then
			c30303016[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c30303016.clear(e,tp,eg,ep,ev,re,r,rp)
	c30303016[0]=true
	c30303016[1]=true
end
function c30303016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c30303016[tp] end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c30303016.splimit)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function c30303016.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xabb)
end
function c30303016.filter(c)
	return c:IsSetCard(0xabb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c30303016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30303016.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c30303016.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c30303016.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
        Duel.BreakEffect()
	    Duel.Damage(tp,tc:GetLevel()*400,REASON_EFFECT)
	end
end
--女王
function c18712304.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--sum limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c18712304.splimit)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65518099,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,18712304)
	e3:SetCost(c18712304.discost)
	e3:SetOperation(c18712304.sumoperation)
	c:RegisterEffect(e3)
	--ritual level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(c18712304.rlevel)
	c:RegisterEffect(e1)
	--direct
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31437713,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,187123040)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c18712304.cost)
	e4:SetTarget(c18712304.target)
	e4:SetOperation(c18712304.operation)
	c:RegisterEffect(e4)
end
c18712304.r_count_limit=1
function c18712304.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0xca1) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c18712304.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xca1) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c18712304.costfilter(c)
	return c:IsSetCard(0xca1) and c:IsReleasable()
end
function c18712304.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c18712304.costfilter,tp,LOCATION_ONFIELD,0,1,c) end
	local g=Duel.SelectTarget(tp,c18712304.costfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.Release(g,REASON_COST)
end
function c18712304.sumoperation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xca1))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c18712304.cfilter(c)
	return c:IsReleasable() and c:IsSetCard(0xca1) 
end
function c18712304.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c18712304.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectTarget(tp,c18712304.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c18712304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18712304.filter,tp,LOCATION_DECK,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,0,tp,1)
end
function c18712304.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c18712304.filter,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c18712304.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xca1) and c:IsAbleToHand()
end
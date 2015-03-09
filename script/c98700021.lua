--时符·永恒的温柔
function c98700021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(c98700021.condition)
	e1:SetCost(c98700021.cost)
	e1:SetOperation(c98700021.activate)
	c:RegisterEffect(e1)
	if c98700021.counter==nil then
		c98700021.counter=true
		c98700021[0]=0
		c98700021[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c98700021.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAINING)
		e3:SetOperation(c98700021.addcount)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_CHAIN_NEGATED)
		e4:SetOperation(c98700021.addcount1)
		Duel.RegisterEffect(e4,0)
	end
end
function c98700021.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c98700021[0]=0
	c98700021[1]=0
end
function c98700021.addcount(e,tp,eg,ep,ev,re,r,rp)
	if re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetCode()~=98700021
		and re:GetHandler():IsSetCard(0x986) then
		c98700021[tp]=c98700021[tp]+1
	end
end
function c98700021.addcount1(e,tp,eg,ep,ev,re,r,rp)
	if re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x986) then
		if c98700021[tp]==0 then c98700021[tp]=1 end
		c98700021[tp]=c98700021[tp]-1
	end
end
function c98700021.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c98700021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98700021)==0 end
	Duel.RegisterFlagEffect(tp,98700021,RESET_PHASE+PHASE_END,0,1)
end
function c98700021.filter(c)
	return c:IsSetCard(0x987) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98700021.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	e1:SetCountLimit(1)
	e1:SetOperation(c98700021.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c98700021.spfilter(c,e,tp)
	return c:IsSetCard(0x987) and c:GetLevel()>=7 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98700021.droperation(e,tp,eg,ep,ev,re,r,rp)
	if (c98700021[tp]+c98700021[1-tp])>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	if (c98700021[tp]+c98700021[1-tp])>1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local sg=Duel.GetMatchingGroup(c98700021.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			Duel.SpecialSummon(sg:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
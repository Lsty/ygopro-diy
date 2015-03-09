--不死鸟重生
function c29800011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29800011+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(c29800011.spcon)
	e1:SetOperation(c29800011.activate)
	c:RegisterEffect(e1)
	if c29800011.counter==nil then
		c29800011.counter=true
		c29800011[0]=0
		c29800011[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c29800011.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_DESTROY)
		e3:SetOperation(c29800011.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function c29800011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return c29800011[tp]>0
end
function c29800011.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c29800011[0]=0
	c29800011[1]=0
end
function c29800011.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x298) then
			local p=tc:GetControler()
			c29800011[p]=c29800011[p]+1
		end
		tc=eg:GetNext()
	end
end
function c29800011.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c29800011.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c29800011.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x298)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c29800011.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,29800011)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29800011.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

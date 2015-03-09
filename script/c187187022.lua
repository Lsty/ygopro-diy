--守护少女的英雄－魏良
function c187187022.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c187187022.spcon)
	e1:SetOperation(c187187022.spop)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c187187022.descon)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c187187022.cost)
	e4:SetTarget(c187187022.target)
	e4:SetOperation(c187187022.operation)
	c:RegisterEffect(e4)	
end
function c187187022.spfilter(c,att)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xabb) and c:IsAbleToDeckAsCost()
end
function c187187022.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c187187022.spfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,2,nil,nil)
end
function c187187022.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c187187022.spfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,2,2,nil,e,tp)
	Duel.SendtoDeck(g,POS_FACEUP,nil,REASON_COST)
	Duel.ShuffleDeck(tp)
end
function c187187022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xabb)
end
function c187187022.descon(e)
	return not Duel.IsExistingMatchingCard(c187187022.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c187187022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c187187022.dfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xabb)
end
function c187187022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c187187022.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c187187022.dfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c187187022.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c187187022.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetCountLimit(1)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
	    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	    tc:RegisterEffect(e2)
	end
end
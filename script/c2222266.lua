--烛光之夜 美夜＆璃纱
function c2222266.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x886),aux.FilterBoolFunction(Card.IsSetCard,0x887),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c2222266.sprcon)
	e2:SetOperation(c2222266.sprop)
	c:RegisterEffect(e2)
	--ind
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c2222266.efilter)
	c:RegisterEffect(e3)
end
function c2222266.spfilter1(c,tp)
	return c:IsSetCard(0x886) and c:IsAbleToDeckAsCost() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c2222266.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c2222266.spfilter2(c)
	return c:IsSetCard(0x887) and c:IsAbleToDeckAsCost() and c:IsCanBeFusionMaterial()
end
function c2222266.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c2222266.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c2222266.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c2222266.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c2222266.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c2222266.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP+TYPE_SPELL) and e:GetHandlerPlayer()~=te:GetHandlerPlayer()
end
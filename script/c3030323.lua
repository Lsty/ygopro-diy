--假面英雄 枯木
function c3030323.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,21143940,aux.FilterBoolFunction(Card.IsSetCard,0xaabb),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c3030323.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c3030323.sprcon)
	e2:SetOperation(c3030323.sprop)
	c:RegisterEffect(e2)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetCondition(c3030323.condition)
	e2:SetOperation(c3030323.activate)
	c:RegisterEffect(e2)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69000994,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(2,3030323)
	e2:SetCondition(c3030323.con)
	e2:SetTarget(c3030323.tg)
	e2:SetOperation(c3030323.op)
	c:RegisterEffect(e2)
end
function c3030323.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c3030323.spfilter1(c,tp)
	return c:IsCode(21143940) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(true)
		and Duel.IsExistingMatchingCard(c3030323.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c3030323.spfilter2(c)
	local tpe=c:GetOriginalType()
	return c:IsSetCard(0xaabb) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c3030323.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c3030323.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp)
end
function c3030323.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48156348,2))
	local g1=Duel.SelectMatchingCard(tp,c3030323.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48156348,3))
	local g2=Duel.SelectMatchingCard(tp,c3030323.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c3030323.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c3030323.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end
function c3030323.cfilter(c,tp)
	return c:IsControler(tp)
end
function c3030323.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c3030323.cfilter,1,nil,1-tp)
end
function c3030323.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c3030323.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetDecktopGroup(tp,1)
	local tc=sg:GetFirst()
	Duel.Draw(tp,1,REASON_EFFECT)
end
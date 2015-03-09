--世界意志 比那名居天子
function c6668630.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c6668630.spcon)
	e1:SetOperation(c6668630.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c6668630.rmtg)
	e4:SetOperation(c6668630.rmop)
	c:RegisterEffect(e4)
	--atk/def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SET_ATTACK)
	e5:SetValue(c6668630.value)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SET_DEFENCE)
	c:RegisterEffect(e6)
end
function c6668630.spfilter(c,tpe)
	return c:IsFaceup() and c:IsSetCard(0x740) and c:IsType(tpe) and c:IsAbleToRemoveAsCost()
end
function c6668630.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c6668630.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_RITUAL)
		and Duel.IsExistingMatchingCard(c6668630.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_FUSION)
		and Duel.IsExistingMatchingCard(c6668630.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_SYNCHRO)
		and Duel.IsExistingMatchingCard(c6668630.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_XYZ)
end
function c6668630.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c6668630.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_RITUAL)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c6668630.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_FUSION)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c6668630.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_SYNCHRO)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g4=Duel.SelectMatchingCard(tp,c6668630.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_XYZ)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c6668630.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x1e,0x1e,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c6668630.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x1e,0x1e,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c6668630.filter(c)
	return c:IsFaceup()
end
function c6668630.value(e,c)
	return Duel.GetMatchingGroupCount(c6668630.filter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*300
end
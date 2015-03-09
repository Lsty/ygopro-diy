--Alice 第一人偶
function c1277.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1277,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1277.spcon)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1277,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1277.condition)
	e2:SetTarget(c1277.target)
	e2:SetOperation(c1277.operation)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetCondition(c1277.discon)
	e4:SetTarget(c1277.distg)
	c:RegisterEffect(e4)
	--cannot
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c1277.econ)
	e5:SetValue(c1277.efilter)
	c:RegisterEffect(e5)
end 
function c1277.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_SPELL+TYPE_TRAP)
		and g:GetCount()==1 and tc:IsSetCard(0x21a) 
end
function c1277.cfilter(c)
	return c:IsSetCard(0x21a) and c:IsType(TYPE_MONSTER)
end
function c1277.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21f)
end
function c1277.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1277.afilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c1277.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c1277.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1277.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1277.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1277.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c1277.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e)  then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c1277.rcon)
		tc:RegisterEffect(e1,true)
	end
end
function c1277.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c1277.distg(e,c)
	return c:IsType(TYPE_TRAP)
end
function c1277.dfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21f)
end
function c1277.discon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c1277.dfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c1277.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c1277.bfilter(c)
	return c:IsFaceup() and c:GetCode()==1274
end
function c1277.econ(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1277.bfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

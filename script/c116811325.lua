--镜世录 雷鸣
function c116811325.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,5)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c116811325.xyzcon)
	e1:SetOperation(c116811325.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c116811325.atkval)
	c:RegisterEffect(e2)
	--return to Spell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(116811325,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c116811325.cost)
	e3:SetTarget(c116811325.target)
	e3:SetOperation(c116811325.op)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetCondition(c116811325.indcon)
	e4:SetValue(c116811325.tgvalue)
	c:RegisterEffect(e4)
end
function c116811325.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x3e2)
end
function c116811325.atkval(e,c)
	return Duel.GetMatchingGroupCount(c116811325.atkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*-100
end
function c116811325.indfilter(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c116811325.indcon(e)
	return Duel.IsExistingMatchingCard(c116811325.indfilter,e:GetOwnerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c116811325.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c116811325.mfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(5) and c:IsSetCard(0x3e2) and not c:IsType(TYPE_XYZ)
end
function c116811325.xyzfilter1(c,g)
	return g:IsExists(c116811325.xyzfilter2,1,c,c:GetLevel())
end
function c116811325.xyzfilter2(c,ll)
	return c:GetLevel()==ll
end
function c116811325.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c116811325.mfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:IsExists(c116811325.xyzfilter1,1,nil,mg)
end
function c116811325.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=Duel.GetMatchingGroup(c116811325.mfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=mg:FilterSelect(tp,c116811325.xyzfilter1,1,1,nil,mg)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=mg:FilterSelect(tp,c116811325.xyzfilter2,1,1,tc1,tc1:GetLevel())
	local tc2=g2:GetFirst()
	g1:Merge(g2)
	local sg1=tc1:GetOverlayGroup()
	local sg2=tc2:GetOverlayGroup()
	sg1:Merge(sg2)
	Duel.SendtoGrave(sg1,REASON_RULE)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end
function c116811325.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c116811325.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x3e2)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c116811325.op(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_GRAVE,0,1,1,nil,0x3e2)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
--轨迹-蔡特
function c20110954.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c20110954.spcon)
	e1:SetTarget(c20110954.sptg)
	e1:SetOperation(c20110954.spop)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c20110954.indtg)
	e3:SetValue(c20110954.indval)
	c:RegisterEffect(e3)
end
function c20110954.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c20110954.filter(c)
	local tpe=c:GetType()
	return c:IsFaceup() and c:IsSetCard(0x929)
end
function c20110954.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c20110954.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c20110954.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20110954.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_UPDATE_ATTACK)
		e6:SetValue(600)
		e6:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e6)
		tc=g:GetNext()
	end
end
function c20110954.indtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x930) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c20110954.indval(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end
--母亲
function c1314589.initial_effect(c)
	--fusion material
	c:SetUniqueOnField(1,0,1314589)
	c:EnableReviveLimit()
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c1314589.sprcon)
	e2:SetOperation(c1314589.sprop)
	c:RegisterEffect(e2)
	--newname
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1314589,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(c1314589.thcon)
	e5:SetTarget(c1314589.target)
	e5:SetOperation(c1314589.spop)
	c:RegisterEffect(e5)
	--fuck new name
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1314589,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetCondition(c1314589.spcon)
	e4:SetTarget(c1314589.sptg)
	e4:SetOperation(c1314589.spop)
	c:RegisterEffect(e4)
	--cannot immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCondition(c1314589.condition)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c1314589.cfilter(c)
	return c:IsFaceup() and c:IsCode(1314588)
end
function c1314589.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1314589.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c1314589.spfilter1(c,tp)
	return c:IsCode(1314588)
end
function c1314589.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c1314589.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil,tp)
end
function c1314589.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c1314589.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,99,nil,tp)
	Duel.Destroy(g1,POS_FACEUP,REASON_COST)
end
function c1314589.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function c1314589.spfilter2(c,tp)
	return c:IsFaceup() and not c:IsCode(1314589)
end
function c1314589.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c1314589.spfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c1314589.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c1314589.spfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	local tg=g:GetFirst()
	while tg do
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetCode(EFFECT_CHANGE_CODE)
			e4:SetRange(LOCATION_ONFIELD)
			e4:SetValue(1314588)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			tg:RegisterEffect(e4)
	tg=g:GetNext()
	end
end
function c1314589.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local rc=tc:GetReasonCard()
	return eg:GetCount()==1 and (rc:IsCode(1314588) or rc:IsCode(1314589))
		and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE)
end
function c1314589.tfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c1314589.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c1314589.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1314589.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c1314589.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetCode(EFFECT_CHANGE_CODE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetValue(1314588)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4)
	end
end
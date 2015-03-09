--戏言·审判罪人·兔吊木垓辅
function c24600021.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,24600011,aux.FilterBoolFunction(Card.IsSetCard,0x246),1,true,true)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c24600021.descon)
	e1:SetTarget(c24600021.destg)
	e1:SetOperation(c24600021.desop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c24600021.indtg)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetTarget(c24600021.indtg)
	c:RegisterEffect(e3)
	--desrep
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c24600021.reptg)
	c:RegisterEffect(e4)
end
function c24600021.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c24600021.filter(c,ec)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not ec:IsHasCardTarget(c)
end
function c24600021.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c24600021.filter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c24600021.filter,tp,0,LOCATION_MZONE,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c24600021.filter,tp,0,LOCATION_MZONE,1,1,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c24600021.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		tc:RegisterFlagEffect(24600021,RESET_EVENT+0x1fe0000,0,0)
	end
end
function c24600021.indtg(e,c)
	return e:GetHandler():IsHasCardTarget(c) and c:GetFlagEffect(24600021)~=0
end
function c24600021.repfilter(c,tp)
	return c:IsControler(tp) and c:GetFlagEffect(24600021)~=0
end
function c24600021.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCardTarget():IsExists(c24600021.repfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(24600021,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=e:GetHandler():GetCardTarget():FilterSelect(tp,c24600021.repfilter,1,1,nil,tp)
		Duel.SendtoGrave(g,REASON_EFFECT)
		return true
	else return false end
end
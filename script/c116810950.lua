--莉莉白and莉莉黑
function c116810950.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c116810950.ffilter,aux.FilterBoolFunction(Card.IsSetCard,0x3e6),false)
	--[[spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c116810950.splimit)
	c:RegisterEffect(e1)]]
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c116810950.sprcon)
	e2:SetOperation(c116810950.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(116810950,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c116810950.setcon)
	e3:SetTarget(c116810950.destg)
	e3:SetOperation(c116810950.desop)
	c:RegisterEffect(e3)
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(116810950,1))
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,116810950)
	e5:SetCondition(c116810950.spcon2)
	e5:SetCost(c116810950.cost1)
	e5:SetTarget(c116810950.sptg2)
	e5:SetOperation(c116810950.spop2)
	c:RegisterEffect(e5)
	--summon success
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(116810950,2))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,116810951)
	e6:SetCondition(c116810950.setcon1)
	e6:SetTarget(c116810950.sptg1)
	e6:SetOperation(c116810950.spop1)
	c:RegisterEffect(e6)
	--activate limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c116810950.setcon)
	e7:SetOperation(c116810950.aclimit1)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e8:SetCode(EVENT_CHAIN_NEGATED)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c116810950.setcon)
	e8:SetOperation(c116810950.aclimit2)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(0,1)
	e9:SetCondition(c116810950.econ)
	e9:SetValue(c116810950.elimit)
	c:RegisterEffect(e9)
end
function c116810950.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c116810950.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c116810950.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c116810950.spfilter1(c,tp)
	return (c:IsCode(116810950) or c:IsCode(116810801) or c:IsCode(116810850)) and c:IsCanBeFusionMaterial() 
		and Duel.IsExistingMatchingCard(c116810950.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c116810950.spfilter2(c)
	return c:IsSetCard(0x3e6) and c:IsCanBeFusionMaterial() 
end
function c116810950.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c116810950.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c116810950.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end
function c116810950.efilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c116810950.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c116810950.efilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c116810950.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and not Duel.IsExistingMatchingCard(c116810950.efilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c116810950.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	    and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c116810950.spop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and not Duel.IsExistingMatchingCard(c116810950.efilter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c116810950.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c116810950.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(116810950,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c116810950.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(116810950)
end
function c116810950.econ(e)
	return e:GetHandler():GetFlagEffect(116810950)~=0 
	    and not Duel.IsExistingMatchingCard(c116810950.efilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c116810950.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c116810950.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c116810950.spop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c116810950.ffilter(c)
	return (c:IsCode(116810950) or c:IsCode(116810801) or c:IsCode(116810850)) and c:IsType(TYPE_MONSTER)
end
function c116810950.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c116810950.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c116810950.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c116810950.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c116810950.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c116810950.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c116810950.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
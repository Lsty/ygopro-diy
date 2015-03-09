--贽殿遮那
function c128909.initial_effect(c)
	c:SetUniqueOnField(1,0,128909)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c128909.eqlimit)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c128909.target)
	e1:SetOperation(c128909.operation)
	c:RegisterEffect(e1)
	--distory
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67775894,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c128909.drcost)
	e4:SetTarget(c128909.destg)
	e4:SetOperation(c128909.desop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(128909,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetTarget(c128909.sptg)
	e3:SetOperation(c128909.spop)
	c:RegisterEffect(e3)
end
function c128909.eqlimit(e,c)
	return c:IsSetCard(0xdfd) and c:IsType(TYPE_XYZ)
end
function c128909.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xdfd) and c:IsType(TYPE_XYZ)
end
function c128909.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c128909.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c128909.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c128909.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c128909.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c128909.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=e:GetHandler()
	local tc=gc:GetEquipTarget()
	if chk==0 then return gc:IsAbleToRemoveAsCost() and gc:GetControler()==gc:GetEquipTarget():GetControler()
		and gc:GetEquipTarget():IsAbleToRemoveAsCost() end
	tc:RegisterFlagEffect(128909,RESET_EVENT+RESET_PHASE+PHASE_END,0,1)
	Duel.Remove(gc,POS_FACEUP,REASON_COST)
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function c128909.tfilter(c)
	return c:IsDestructable()
end
function c128909.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c128909.tfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c128909.tfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c128909.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c128909.tfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c128909.spfilter(c,e,tp)
	return c:GetFlagEffect(128909)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c128909.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingTarget(c128909.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c128909.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c128909.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		Duel.Overlay(tc,e:GetHandler())
	end
end

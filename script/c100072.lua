--虹之奇迹 
function c100072.initial_effect(c)
	--同调召唤
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100072111+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c100072.sycon)
	e1:SetCost(c100072.cost)
	e1:SetTarget(c100072.target)
	e1:SetOperation(c100072.activate)
	c:RegisterEffect(e1)
	--超量召唤
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,100072222+EFFECT_COUNT_CODE_DUEL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c100072.spcon)
	e2:SetCost(c100072.necost)
	e2:SetTarget(c100072.netarget)
	e2:SetOperation(c100072.neactivate)
	c:RegisterEffect(e2)
end
function c100072.afilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c100072.sycon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c100072.afilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100072.cfilter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c100072.cfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,e,tp,c)
end
function c100072.cfilter2(c,e,tp,tc)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c100072.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel()+tc:GetLevel())
end
function c100072.spfilter(c,e,tp,lv)
	return c:IsSetCard(0xf70) and c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100072.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(c100072.cfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c100072.cfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c100072.cfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst())
	g1:Merge(g2)
	e:SetLabel(g1:GetFirst():GetLevel()+g2:GetFirst():GetLevel())
	Duel.SendtoDeck(g1,nil,0,REASON_COST)
end
function c100072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100072.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100072.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
function c100072.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE)>0 and
		Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_ONFIELD,0)==0
end
function c100072.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100072.filter(c,e)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
end
function c100072.xyzfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsSetCard(0xf70) and c:IsType(TYPE_XYZ)
end
function c100072.netarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c100072.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100072.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100072.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100072.neactivate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100072.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		Duel.Overlay(sc,mg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
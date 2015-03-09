--LabMem No.002-嘟嘟噜
function c20400012.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c20400012.descon)
	e1:SetTarget(c20400012.destg)
	e1:SetOperation(c20400012.desop)
	c:RegisterEffect(e1)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CVAL_CHECK)
	e4:SetCost(c20400012.cost)
	e4:SetTarget(c20400012.sptg)
	e4:SetOperation(c20400012.spop)
	c:RegisterEffect(e4)
	if not LabMemGlobal then
		LabMemGlobal={}
		LabMemGlobal["Effects"]={}
	end
	LabMemGlobal["Effects"]["c20400012"]=e4
end
function c20400012.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c20400012.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove()) or (chkc:IsLocation(LOCATION_REMOVED)) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) or Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then
		g:Merge(Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil))
	end
	local mg=g:Select(tp,1,3,nil)
	Duel.SetTargetCard(mg)
	local mg1=mg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local mg2=mg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	e:SetLabelObject(mg1:GetFirst())
	if mg1:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,mg1,mg1:GetCount(),0,0)
	end
	if mg2:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,mg2,mg2:GetCount(),0,0)
	end
end
function c20400012.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mg=g:Filter(Card.IsRelateToEffect,nil,e)
	local mg1=mg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local mg2=mg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	if mg1:GetCount()>0 then Duel.Remove(mg1,POS_FACEUP,REASON_EFFECT) end
	if mg2:GetCount()>0 then Duel.SendtoGrave(mg2,REASON_EFFECT+REASON_RETURN) end
end
function c20400012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.cfilter,tp,LOCATION_HAND,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c20400012.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20400012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c20400012.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c20400012.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c20400012.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
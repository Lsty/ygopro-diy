--天津祸土 岚龙
function c11112039.initial_effect(c)
    --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x15b),aux.NonTuner(Card.IsSetCard,0x15b),2)
	c:EnableReviveLimit()
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c11112039.matcheck)
	c:RegisterEffect(e1)
	--synchro success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112039,8))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11112039+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c11112039.condition)
	e2:SetTarget(c11112039.target)
	e2:SetOperation(c11112039.operation)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--cannot be destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--spsummon2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11112039,7))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetCondition(c11112039.spcon)
	e4:SetTarget(c11112039.sptg)
	e4:SetOperation(c11112039.spop)
	c:RegisterEffect(e4)
end
function c11112039.matcheck(e,c)
	local ct=c:GetMaterial():Filter(Card.IsSetCard,nil,0x15b):GetClassCount(Card.GetCode)
	e:SetLabel(ct)
end	
function c11112039.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c11112039.filter(c)
	return c:IsSetCard(0x15b) and c:IsAbleToDeck()
end
function c11112039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabelObject():GetLabel()
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil)
	local b3=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
	local b4=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil)
	local b5=Duel.IsExistingMatchingCard(c11112039.filter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return ct>0 and (b1 or b2 or b3 or b4 or b5) end
end
function c11112039.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
	    if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(11112039,0)) then
		    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		    local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			ct=ct-1
		end
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
	    if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(11112039,1)) then
			local sg=g:RandomSelect(tp,1)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			ct=ct-1
		end
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
	    if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(11112039,2)) then
		    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		    local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
		    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			ct=ct-1
		end	
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()>0 then
	    if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(11112039,3)) then
		    Duel.ConfirmCards(tp,g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			ct=ct-1
		end
	end
	local g=Duel.GetMatchingGroup(c11112039.filter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
	    if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(11112039,4)) then
		    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		    local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
		    local tc=sg:GetFirst()
		    if tc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
			    or Duel.SelectOption(tp,aux.Stringid(11112039,5),aux.Stringid(11112039,6))==0 then
			    Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		    else
			    Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
			end	
		end
	end
end
function c11112039.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c11112039.spfilter(c,e,tp)
	return c:IsSetCard(0x15b) and not c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11112039.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11112039.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11112039.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c11112039.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c11112039.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
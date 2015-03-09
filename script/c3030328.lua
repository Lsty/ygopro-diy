--女仆少女 艾莉叶特
function c3030328.initial_effect(c)
   	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28637168,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,3030328)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c3030328.target)
	e1:SetOperation(c3030328.operation)
	c:RegisterEffect(e1)
end
function c3030328.filter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c3030328.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c3030328.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c3030328.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c3030328.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) then
	local lv=tc:GetLevel()
	e:SetLabel(lv)
	local ct=e:GetLabel()
	if ct<=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0	and Duel.IsExistingTarget(c3030328.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp)  then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c3030328.spfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if ct==3 or ct==4 and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 then
	Duel.SetTargetPlayer(1-tp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,Duel.GetFieldGroupCount(p,LOCATION_HAND,0)*300,REASON_EFFECT)
	end
	if ct>=5 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0	and Duel.IsExistingTarget(c3030328.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c3030328.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end
function c3030328.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x3ad)
end
function c3030328.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xaabb)
end
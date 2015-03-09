--�����������  йʸ������
function c329403.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(329403,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,329403)
    e1:SetTarget(c329403.sptg)
    e1:SetOperation(c329403.spop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetDescription(aux.Stringid(329403,1))
    e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,329403)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetTarget(c329403.sptg2)
    e2:SetOperation(c329403.spop2)
    c:RegisterEffect(e2)
end
function c329403.rmfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c329403.filter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c329403.filter(c,e,tp)
    return c:IsSetCard(0x301) and c:GetCode()~=329403 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c329403.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c329403.rmfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c329403.rmfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c329403.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c329403.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then 
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local sg=Duel.GetMatchingGroup(c329403.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
			if sg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				Duel.SpecialSummon(sg:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c329403.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c329403.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end


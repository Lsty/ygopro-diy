--传说之弓兵 阿塔兰忒
function c999999959.initial_effect(c)
	c:SetUniqueOnField(1,0,999999959)
	--sumlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(c999999959.excon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
	--spsummon(hand)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	c:RegisterEffect(e4)
	--cannot be battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetTarget(c999999959.atktg)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--spsummon(grave)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(999999959,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,999999959+EFFECT_COUNT_CODE_OATH)
	e6:SetCost(c999999959.hspcost)
	e6:SetTarget(c999999959.hsptg)
	e6:SetOperation(c999999959.hspop)
	c:RegisterEffect(e6)
	--search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(999999959,1))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetCountLimit(1,999999959+EFFECT_COUNT_CODE_OATH)
	e7:SetTarget(c999999959.tg)
	e7:SetOperation(c999999959.op)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
	--synchro limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(c999999959.limit)
	c:RegisterEffect(e9)
	--xyz limit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetValue(c999999959.limit)
	c:RegisterEffect(e10)
end
function c999999959.excon(e,c)
	local c=e:GetHandler()
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)==0
end
function c999999959.atktg(e,c)
	return c:IsFaceup() and c~=e:GetHandler()
end
function c999999959.rfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
end
function c999999959.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999959.rfilter,tp,LOCATION_GRAVE,0,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c999999959.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c999999959.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c999999959.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c999999959.filter(c)
	local code=c:GetCode()
	return (code==999999957 or code==999999958) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c999999959.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999959.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999959.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c999999959.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end

end
function c999999959.limit(e,c)
	if not c then return false end
	return not (c:IsSetCard(0x984) or c:IsSetCard(0x985))
end
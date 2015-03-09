--使徙少女的超再生能力
function c187187017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12469386,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROY)
	e1:SetCountLimit(1)
	e1:SetCondition(c187187017.spcon)
	e1:SetTarget(c187187017.target)
	e1:SetOperation(c187187017.operation)
	c:RegisterEffect(e1)
end
function c187187017.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x3abb) 
end
function c187187017.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c187187017.filter,1,nil,tp)
end
function c187187017.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,202,tp,false,false) and c:IsSetCard(0x3abb) 
end
function c187187017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c187187017.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetFlagEffect(tp,187187017)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c187187017.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c187187017.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.RegisterFlagEffect(tp,187187017,RESET_PHASE+PHASE_END,0,1)
end
function c187187017.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,202,tp,tp,false,false,POS_FACEUP) then
		Duel.SpecialSummonComplete()
	end
end
--Requipped Warrior Ophelia
function c77777815.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777815,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,77777815)
	e1:SetTarget(c77777815.sptg)
	e1:SetOperation(c77777815.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777815,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetTarget(c77777815.eqtg)
	e4:SetOperation(c77777815.eqop)
	c:RegisterEffect(e4)
end

function c77777815.eqfilter(c,ec)
	return c:IsSetCard(0x408) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c77777815.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--flag effect is set to allow the cards to be activated directly from the deck,
	--even though the monster is potentially already equipped with a Requipped card.
	e:GetHandler():RegisterFlagEffect(77777812,RESET_EVENT+0x1fe0000,0,1)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c77777815.eqfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	e:GetHandler():ResetFlagEffect(77777812)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c77777815.eqop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetEquipGroup():GetCount()>0 then
		local g2=e:GetHandler():GetEquipGroup()
		Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x408)then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c77777815.eqfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c,true)
	end
end

function c77777815.filter(c,e,tp)
	return c:IsSetCard(0x408) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777815.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77777815.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77777815.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77777815.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77777815.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
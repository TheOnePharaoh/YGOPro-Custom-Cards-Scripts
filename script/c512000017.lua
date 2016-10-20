--CNo.101 S・H・Dark Knight
function c512000017.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12744567,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12744567)
	e1:SetTarget(c512000017.target)
	e1:SetOperation(c512000017.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12744567,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12744567)
	e2:SetCondition(c512000017.spcon)
	e2:SetTarget(c512000017.sptg)
	e2:SetOperation(c512000017.spop)
	c:RegisterEffect(e2)
	--sp summon 101
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(102380,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,12744567)
	e3:SetCondition(c512000017.spcon2)
	e3:SetCost(c512000017.spcost2)
	e3:SetTarget(c512000017.sptg2)
	e3:SetOperation(c512000017.spop2)
	c:RegisterEffect(e3)
	if not c512000017.global_check then
		c512000017.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c512000017.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c512000017.xyz_number=101
function c512000017.filter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end
function c512000017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c512000017.filter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(c512000017.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c512000017.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c512000017.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c512000017.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()>0
end
function c512000017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local rec=e:GetHandler():GetBaseAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c512000017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
function c512000017.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,48739166)
end
function c512000017.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_COST)	
end
function c512000017.spfilter(c,e,tp)
	return c:IsCode(48739166) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c512000017.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c512000017.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c512000017.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c512000017.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c512000017.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,12744567)
	Duel.CreateToken(1-tp,12744567)
end

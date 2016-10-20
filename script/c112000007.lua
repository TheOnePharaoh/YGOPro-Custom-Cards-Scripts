--Millennium Beyonder
function c112000007.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c112000007.spcon)
	e1:SetOperation(c112000007.spop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--unaffectable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(c112000007.immfilter)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	c:RegisterEffect(e5)
	--send hand cards to grave
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_HANDES)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetDescription(aux.Stringid(112000007,0))
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetTarget(c112000007.target)
	e6:SetOperation(c112000007.operation)
	c:RegisterEffect(e6)
	--spsummon monster effect
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(112000007,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c112000007.spmtg)
	e7:SetOperation(c112000007.spmop)
	c:RegisterEffect(e7)
	--atkup
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(c112000007.val)
	c:RegisterEffect(e8)
	--avoid battle damage
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(1,0)	
	e9:SetCondition(c112000007.dmgcondition)
	c:RegisterEffect(e9)
	--banishrevenge
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(112000007,2))
	e10:SetCategory(CATEGORY_REMOVE)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_BATTLE_DESTROYED)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(c112000007.bancon)
	e10:SetTarget(c112000007.bantg)
	e10:SetOperation(c112000007.banop)
	c:RegisterEffect(e10)
	--death spsummon
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(112000007,1))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e11:SetCode(EVENT_LEAVE_FIELD)
	e11:SetCondition(c112000007.deacon)
	e11:SetTarget(c112000007.deatg)
	e11:SetOperation(c112000007.deaop)
	c:RegisterEffect(e11)
end
function c112000007.immfilter(e,c)
	return c~=e:GetHandler()
end
function c112000007.spfilter(c,code)
	return c:GetTextAttack()==2500
end
function c112000007.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-5
		and Duel.CheckReleaseGroup(c:GetControler(),c112000007.spfilter,5,nil,c)
end
function c112000007.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c112000007.spfilter,5,5,nil,c)
	Duel.Release(g,REASON_COST)
end
function c112000007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,0)
end
function c112000007.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c112000007.mfilter(c,e,tp)
	return c:GetAttack()==2500 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112000007.spmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c112000007.mfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c112000007.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c112000007.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c112000007.spmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c112000007.val(e,c)
	return Duel.GetMatchingGroupCount(c112000007.valfilter,c:GetControler(),LOCATION_MZONE,0,nil)*500
end
function c112000007.valfilter(c)
	return c:IsFaceup() and c:GetTextAttack()==2500
end
function c112000007.dmgcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c112000007.valfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c112000007.banfilter(c)
	return c:IsReason(REASON_BATTLE) and c:GetTextAttack()==2500
end
function c112000007.bancon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c112000007.banfilter,1,e:GetHandler())
end
function c112000007.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c112000007.banop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c112000007.deacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c112000007.deatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c112000007.mfilter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c112000007.deaop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c112000007.mfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end

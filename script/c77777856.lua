--Mystic Fauna Jaglider
function c77777856.initial_effect(c)
  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),2,2)
	c:EnableReviveLimit()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
  --disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c77777856.distg)
	c:RegisterEffect(e2)
  --effect damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetTarget(c77777856.damtg)
	e3:SetOperation(c77777856.damop)
	c:RegisterEffect(e3)
  --Indes s/t effects
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c77777856.efilter)
	c:RegisterEffect(e4)
  --spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(77777856,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCost(c77777856.cost)
	e7:SetTarget(c77777856.target)
	e7:SetOperation(c77777856.operation)
	c:RegisterEffect(e7)
end
function c77777856.distg(e,c)
	return c:IsLevelAbove(4) or c:IsRankAbove(4)
end
function c77777856.efilter(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end


function c77777856.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(Duel.GetTurnPlayer())
  local sum=0
  for i=0,4 do
		local tc=Duel.GetFieldCard(Duel.GetTurnPlayer(),LOCATION_MZONE,i)
		if tc and tc:IsFaceup() then
			if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
			else sum=sum+tc:GetLevel() end
		end
	end
	Duel.SetTargetParam(sum*100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,sum*100)
end
function c77777856.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
  local sum=0
  for i=0,4 do
		local tc=Duel.GetFieldCard(Duel.GetTurnPlayer(),LOCATION_MZONE,i)
		if tc and tc:IsFaceup() then
			if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
			else sum=sum+tc:GetLevel() end
		end
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,sum*100,REASON_EFFECT)
end
--[[
function c77777856.matop(e,tp,eg,ep,ev,re,r,rp)
  	local mt=eg:GetFirst()
    if mt then mt=mt:Filter(Card.IsAbleToDeck,nil)end
    mt:CancelToGrave()
    Duel.SendtoDeck(mt,nil,2,REASON_EFFECT)
end]]--

function c77777856.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77777856.spfilter(c,e,tp)
	return c:IsSetCard(0x40a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777856.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_HAND) and chkc:IsControler(tp) and c77777856.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77777856.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77777856.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77777856.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

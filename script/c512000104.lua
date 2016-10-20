--Number 5: Des Chimera Dragon
function c512000104.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,nil,nil,5)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c512000104.atkval)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000509,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCost(c512000104.spcost)
	e2:SetTarget(c512000104.sptg)
	e2:SetOperation(c512000104.spop)
	c:RegisterEffect(e2)
	--register effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511000509,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c512000104.cost)
	e3:SetCondition(c512000104.condition)
	e3:SetOperation(c512000104.operation)
	c:RegisterEffect(e3)
end
c512000104.xyz_number=5
function c512000104.atkval(e,c)
	return c:GetOverlayCount()*900
end
function c512000104.spfilter(c)
	return c:GetLevel()==5
end
function c512000104.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) end
	local lp=Duel.GetLP(tp)
	local ct=Duel.GetMatchingGroupCount(c512000104.spfilter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)
	local t={}
	local l=1
	while l<=ct and l*1200<lp do
		t[l]=l*1200
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000509,1))
	local announce=Duel.AnnounceNumber(e:GetHandler():GetControler(),table.unpack(t))
	Duel.PayLPCost(tp,announce)
	e:SetLabel(announce/1200)
end
function c512000104.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.IsExistingMatchingCard(c512000104.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c512000104.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c512000104.spfilter,tp,LOCATION_GRAVE,0,ct,ct,nil)
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetOperation(c512000104.xyzop)
		e1:SetReset(RESET_CHAIN)
		e1:SetValue(SUMMON_TYPE_XYZ)
		e1:SetLabelObject(g)
		c:RegisterEffect(e1)
		Duel.XyzSummon(tp,c,nil)
	end
end
function c512000104.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mat=e:GetLabelObject()
	c:SetMaterial(mat)
	Duel.Overlay(c,mat)
end
function c512000104.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c512000104.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c512000104.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c512000104.atcon)
	e1:SetOperation(c512000104.atop)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c512000104.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable()
end
function c512000104.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end

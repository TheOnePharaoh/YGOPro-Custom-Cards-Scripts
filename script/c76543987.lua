--Cyber Dragon Null
function c76543987.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c76543987.mfilter,8,3,c76543987.ovfilter, aux.Stringid(76543987,0),3,c76543987.xyzop)
	c:EnableReviveLimit()
	--Xyz revive
	local e1=Effect.CreateEffect(c)
	e1:SetDescription (76543987, 1)
	e1:SetCountLimit(1)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c76543987.cost)
	e1:SetTarget(c76543987.sumtg)
	e1:SetOperation(c76543987.sumop)
	c:RegisterEffect(e1)
	--atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVED)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c76543987.atk)
    c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(76543987,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCondition(c76543987.condition)
	e3:SetCost(c76543987.cost)
	e3:SetTarget(c76543987.target)
	e3:SetOperation(c76543987.operation)
	c:RegisterEffect(e3)
end

function c76543987.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1093) and c:IsType(TYPE_XYZ) and not c:IsCode(76543987)
end

function c76543987.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c76543987.mfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c76543987.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,76543987)==0 end
	Duel.RegisterFlagEffect(tp,76543987,RESET_PHASE+PHASE_END,0,1)
end

function c76543987.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c76543987.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c76543987.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c76543987.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c76543987.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c76543987.sumop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end

function c76543987.atk(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasType(0x7f0) and rp==tp then
        local ae=e:GetLabelObject()
        if ae then
            ae:SetValue(ae:GetValue()+600)
        else
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetReset(RESET_EVENT+0x1ff0000)
            e1:SetValue(600)
            e:GetHandler():RegisterEffect(e1)
            e:SetLabelObject(e1)
        end
    end
end

function c76543987.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(c76543987.nfilter,1,nil)
end

function c76543987.nfilter(c)
	return c:IsType(TYPE_MONSTER)
end

function c76543987.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c76543987.nfilter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c76543987.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c76543987.nfilter,nil)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
